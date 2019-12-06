# 公式のイメージ
FROM ruby:2.6.0

# Dockerfile内部の変数
ARG RAILS_ENV
ARG RAILS_MASTER_KEY

# コンテナ内のルートを/appに
ENV APP_ROOT /app

# 環境変数化
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

# コンテナ内のルート
WORKDIR $APP_ROOT

# ローカルのGemfileなどをコピー
ADD Gemfile $APP_ROOT
ADD Gemfile.lock $APP_ROOT

# bundle install実行
RUN \
        gem install bundler:1.17.2 && \
        bundle install && \
        rm -rf ~/.gem

# 他のファイルも
ADD . $APP_ROOT

# プロダクション
RUN if ["${RAILS_ENV}" = "production"]; then bundle exec rails assets:precompile; else export RAILS_ENV=developmnet; fi

# ポート3000番
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
